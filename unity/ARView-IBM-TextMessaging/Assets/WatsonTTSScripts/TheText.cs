using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
///////////////////////////////////
//////////////////////////////////
// NOT IN USE//
/// <summary>
/// /////////////////////////
/// </summary>

public class TheText : MonoBehaviour
{
    [SerializeField]
    private GameObject targetGameObject;
    //private InputField textInput; // The text input field the user types text into
    public string s; //The text give by nlu
    // Start is called before the first frame update

    public int index;
    private WasonNLU wasonNLU;
    private watsonNLUTTSIF watsonService;
     void Start()
    {
        Debug.Log("StartTheText");
        index = 0;
        wasonNLU = new WasonNLU();
        watsonService = new watsonNLUTTSIF();
    }

    // Update is called once per frame
    void Update()
    {
        if (index == 1)
        {
            Debug.Log("send str");
            index++;
            GameObject.Find("WatsonTTSAndNLU").SendMessage("AddTextToQueue", s);
            wasonNLU.sendTextToNLU(s);
            s = string.Empty;
        }
        if (wasonNLU.getResult() != null)
        {
            string re;
            re = wasonNLU.getResult();
            parserForNLU p = new parserForNLU();
            int index = p.parse1(re);
            Debug.Log("NLU result String " + re);
            Debug.Log(index);
            wasonNLU.clean();
        }
    }
    // Update is called once per frame
    /*void Update()
    {
        if (index == 1)
        {
            Debug.Log("send str");
            index++;
            watsonService = new watsonNLUTTSIF(s);
            *//*GameObject.Find("WatsonTTSAndNLU").SendMessage("AddTextToQueue", s);
            wasonNLU.sendTextToNLU(s);*//*
            s = string.Empty;
        }
        if (watsonService.getNLUResult() != null)
        {
            string re;
            re = watsonService.getNLUResult();
            parserForNLU p = new parserForNLU();
            int index = p.parse1(re);
            Debug.Log("NLU result String " + re);
            Debug.Log("NLU result emotion "+index);
            //wasonNLU.clean();
        }
    }*/


    public void sendTextToTTS(string str)
    {
        s = str;
        index = 1;

    }
    public void sendTextToNLU(string str)
    {
        

    }



}
