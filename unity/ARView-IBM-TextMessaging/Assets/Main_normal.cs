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
public class Main_normal : MonoBehaviour
{
    [Header("AR Object To Place")]
    public GameObject objectToPlace;

    [Header("Message Input")]
    public TMP_InputField messageInput;
    public Button confirmActionButton;

    //watson NLU & TTS
    private watsonNLUTTSIF watsonService;
    //whether audio is playing in the last frame
    private bool isPlaying_lastframe = false;
    //message
    private string message;
    private int messageSignal = -1;
    //emotion
    private int emotionSignal = 0;
    //animation controller
    private ARObjectControl curARObjControl;

    private void Awake()
    {
        confirmActionButton.onClick.AddListener(OnConfirmAction);
    }

    void Start()
    {
        curARObjControl = objectToPlace.GetComponent<ARObjectControl>();
        watsonService = new watsonNLUTTSIF();
    }

    void Update()
    {
        if (messageSignal == 9)
        {
            SceneManager.LoadScene("MainAR");
            messageSignal = -1;
        }
        
        if (messageSignal == 1)
        {        
            //watsonService = new watsonNLUTTSIF(message);
            // watsonService.NLUAnalyze(message); 
            // //watsonService.soundTTS();
            // //message = string.Empty;
            // messageSignal++;
            // watsonService.soundTTS(message);
            try{
                //watsonService = new watsonNLUTTSIF(message);
                watsonService.NLUAnalyze(message);
            }
            catch(Exception e)
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
            messageSignal = -1;
        }
        // NLU TTS    
        if(watsonService.getNLUResult()!=null && messageSignal ==2) {
            emotionSignal = watsonService.getEmotion();
            Debug.Log("emotionSignal " + emotionSignal);
            
            messageSignal = -1;
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
                emotionSignal = 0;
        }
            
    }
        



    #region 
    // Actions after pressing confirm button
    private void OnConfirmAction()
    {
        string message_flutter = messageInput.text;
        if (message_flutter.Substring(1,1)==":") {
            messageSignal = int.Parse(message_flutter.Substring(0,1));
            message = message_flutter.Remove(0,2);
        }
              
    }
    #endregion
}



