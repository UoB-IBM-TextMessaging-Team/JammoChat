using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Config : MonoBehaviour
{
    //version_code 
    public static string version_code = "v1.0.0";

    //AR status
    public static AR_statu ar_statu=AR_statu.recognizing;

    public Config()
    {

    }

}

//AR status
public enum AR_statu
{
    recognizing,                           //Recognizing plane
    object_is_placed                       //AR object is placed
}