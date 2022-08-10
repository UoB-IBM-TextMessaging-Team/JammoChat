using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARSubsystems;
using UnityEngine.XR.ARFoundation;
using UnityEngine.SceneManagement;

public class Device_check : MonoBehaviour
{
    [SerializeField] ARSession m_Session;

    IEnumerator Start()
    {
        ARSession.stateChanged += ARSession_stateChanged;

        if ((ARSession.state == ARSessionState.None) || (ARSession.state == ARSessionState.CheckingAvailability))
        {
            yield return ARSession.CheckAvailability();
        }

        if (ARSession.state == ARSessionState.Unsupported)
        {
          
        }
        else
        {
            // Start the AR session
            m_Session.enabled = true;
        }
    }
    private void ARSession_stateChanged(ARSessionStateChangedEventArgs obj)
    {
        //throw new System.NotImplementedException();
    }
}
