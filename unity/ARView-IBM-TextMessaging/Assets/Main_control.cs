using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.ARSubsystems;
using UnityEngine.XR.ARFoundation;
using UnityEngine.SceneManagement;
using TMPro;
using System.Threading.Tasks;
using System;
using System.Threading;


public class Main_control : MonoBehaviour
{
    [Header("AR Object To Place")]
    public GameObject objectToPlace;

    [Header("Placement Indicator")]
    public GameObject placementIndicator;

    [Header("Button To Place")]
    public GameObject gameobject_place_btn;

    [Header("Button To Reset")]
    public GameObject gameobject_reset_btn;

    [Header("Hint Text")]
    public GameObject gameobject_hint_text;

    [Header("Message Input")]
    public TMP_InputField messageInput;
    public Button confirmActionButton;

    //Placement positon in reality
    private Pose placementPose;

    //If the plane is recognized
    private bool placementPoseIsValid = false;

    //AR data source
    private ARSessionOrigin arOrigin;

    //AR object controller
    private ARObjectControl curARObjControl;

    //AR foundation raycast object
    private ARRaycastManager raycastManager;

    //watson NLU & TTS
    private watsonNLUTTSIF watsonService;
    private WasonNLU WasonNLUService = new WasonNLU();
    private TextToSpeech TextToSpeechService = new TextToSpeech();
    //whether audio is playing in the last frame
    private bool isPlaying_lastframe = false;
    //message
    private string message;
    private int messageSignal = -1;
    //emotion
    private int emotionSignal = 0;
    
    private void Awake()
    {
        confirmActionButton.onClick.AddListener(OnConfirmAction);
    }

    void Start()
    {
        //Find ar origin
        this.arOrigin = FindObjectOfType<ARSessionOrigin>();

        //Find AR raycast object
        this.raycastManager = FindObjectOfType<ARRaycastManager>();

        //Change to recognizing status
        this.change_to_recognizing();

        //Init Watson NLU & TTS
        this.watsonService = new watsonNLUTTSIF();
    }

    void Update()
    {
        //When AR status is recognizing
        if (Config.ar_statu == AR_statu.recognizing)
        {
            //Update plane position/if recognized
            this.UpdatePlacementPose();

            //Update placement indicator position/if display
            this.UpdatePlacementIndicator();
        }
        //When AR status is object_is_placed
        else if (Config.ar_statu == AR_statu.object_is_placed)
        {
            /*if (messageSignal == 1)
            {
                //watsonService = new watsonNLUTTSIF(message);
                watsonService.NLUAnalyze(message);
                //watsonService.soundTTS();
                //message = string.Empty;
                messageSignal++;
                watsonService.soundTTS(message);
            }*/
            if (messageSignal == 1)
            {
                //watsonService = new watsonNLUTTSIF(message);
                // watsonService.NLUAnalyze(message); 
                // //watsonService.soundTTS();
                // //message = string.Empty;
                // messageSignal++;
                // watsonService.soundTTS(message);
                try
                {
                    //watsonService = new watsonNLUTTSIF(message);
                    watsonService.NLUAnalyze(message);
                }
                catch (Exception e)
                {
                    Debug.Log("watsonService.NLUAnalyze() Exception:" + e.Message);
                }
                finally
                {
                    //watsonService.soundTTS();
                    //message = string.Empty;
                    messageSignal++;
                    watsonService.soundTTS(message);
                }
            }
            else if (messageSignal == 0)
            {
                watsonService.destroyAudio();
                curARObjControl.Animator.SetTrigger("normal");
            }
            // NLU TTS    
            if(watsonService.getNLUResult()!=null && messageSignal ==2) {
                emotionSignal = watsonService.getEmotion();
                Debug.Log("emotionSignal " + emotionSignal);
            
                messageSignal++;
                watsonService.clean();
            }
            //Animate
            if (watsonService.getStatusOfAudio() && (!isPlaying_lastframe)) {
                switch(emotionSignal)
                {
                    case 1:
                        curARObjControl.Animator.SetTrigger("sadness");
                        break;
                    case 2:
                        curARObjControl.Animator.SetTrigger("joy");
                        break;
                    case 3:
                        curARObjControl.Animator.SetTrigger("fear");
                        break;
                    case 4:
                        curARObjControl.Animator.SetTrigger("disgust");
                        break;
                    case 5:
                        curARObjControl.Animator.SetTrigger("anger");
                        break;
                    default:
                        curARObjControl.Animator.SetTrigger("talking");
                        break;
                }
                isPlaying_lastframe = true;
                emotionSignal = 0;
            }
            else if ((!watsonService.getStatusOfAudio()) && isPlaying_lastframe) {
                curARObjControl.Animator.SetTrigger("normal");
                isPlaying_lastframe = false;
            }
        }

    }

    //Change to recognizing status
    public void change_to_recognizing()
    {
        //Set AR status recognizing
        Config.ar_statu = AR_statu.recognizing;

        //Destroy AR object placed
        GameObject[] objs = GameObject.FindGameObjectsWithTag("ARObject");
        for (int i = 0; i < objs.Length; i++)
        {
            Destroy(objs[i].gameObject);
        }

        //Hide place button
        this.gameobject_place_btn.SetActive(false);

        //Hide reset button
        this.gameobject_reset_btn.SetActive(false);

        //Hide message input area
        messageInput.gameObject.SetActive(false);
    }

    //Change to AR object is placed status
    public void change_to_object_is_placed()
    {
        //Set AR status object_is_placed
        Config.ar_statu = AR_statu.object_is_placed;

        //Place AR object
        this.PlaceObject();

        //Display reset button
        this.gameobject_reset_btn.SetActive(true);

        //Display place button
        this.gameobject_place_btn.SetActive(false);

        //Hide placement indicator
        this.placementIndicator.SetActive(false);

        //Display message input area
        messageInput.gameObject.SetActive(true);
    }

    //Update plane position/if recognized
    private void UpdatePlacementPose()
    {
        var screenCenter = Camera.main.ViewportToScreenPoint(new Vector3(0.5f, 0.5f));

        var hits = new List<ARRaycastHit>();

        //Check placement plane if valid
        this.raycastManager.Raycast(screenCenter, hits, TrackableType.Planes);
        this.placementPoseIsValid = hits.Count > 0;

        if (this.placementPoseIsValid)
        {
            this.placementPose = hits[0].pose;

            //Distance from plane to phone camera
            float distance = (this.placementPose.position - Camera.main.transform.position).sqrMagnitude;

            //Placement plane invalid when plane is too close/far away
            if (distance < 0.35f || distance > 4.5f)
                this.placementPoseIsValid = false;
            else
            {
                var cameraForward = Camera.current.transform.forward;
                var cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;

                this.placementPose.rotation = Quaternion.LookRotation(cameraBearing);
            }

        }
    }

    //Update placement indicator position/if display
    private void UpdatePlacementIndicator()
    {
        if (this.placementPoseIsValid)
        {
            //Display indicator
            this.placementIndicator.SetActive(true);
            this.placementIndicator.transform.SetPositionAndRotation(this.placementPose.position, this.placementPose.rotation);

            //Hide hint text; Display place button
            this.gameobject_hint_text.SetActive(false);
            this.gameobject_place_btn.SetActive(true);
        }
        else
        {
            //Hide indicator 
            this.placementIndicator.SetActive(false);

            //Display hint text; Hide place button
            this.gameobject_hint_text.SetActive(true);
            this.gameobject_place_btn.SetActive(false);
        }
    }

    //Place object
    private void PlaceObject()
    {
        GameObject newObj = Instantiate(this.objectToPlace, this.placementPose.position, this.placementPose.rotation);
        curARObjControl = newObj.GetComponent<ARObjectControl>();
    }

    #region 
   //Actions after pressing place button
    public void on_reset_btn()
    {
        //Play sound
        Audio_control.instance.play_btn_sound();

        //Change to recognizing status
        this.change_to_recognizing();
    }

    //Actions after pressing back button
    public void on_back_btn()
    {
        SceneManager.LoadScene("MainNormal");
    }

    //Actions after pressing place button
    public void on_place_btn()
    {
        //Place object
        GameObject[] objs = GameObject.FindGameObjectsWithTag("ARObject");
        if(objs.Length == 0)
        {
            this.change_to_object_is_placed();
            this.gameobject_hint_text.SetActive(false);
        }
        
    }

    // Actions after pressing confirm button
    private void OnConfirmAction()
    {
        string message_flutter = messageInput.text;
        if (message_flutter.Substring(1,1)==":") {
            messageSignal = int.Parse(message_flutter.Substring(0,1));
            message = message_flutter.Remove(0,2);
        }
        
    }

    private void StartPlayMessage(string text)
    {
        messageSignal = 1;
        message = text;
    }
    #endregion

    //Global language settings  
    public void setGlobalNLULanguage(string inputLanguage)
    {
        this.WasonNLUService.setNLULanguage(inputLanguage);   
    }

    public void setGlobalVoice(string inputVoice, string inputLanguage)
    {
        this.TextToSpeechService.setVoice(inputVoice, inputLanguage);
    }

    public void setGlobalVoiceTemp(string inputVoice)
    {
        this.TextToSpeechService.setVoice(inputVoice, "en");
    }

}



