using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StartScene : MonoBehaviour
{
    public Button enterButton;

    private void Awake()
    {
        enterButton.onClick.AddListener(OnEnter);
    }

    private void OnEnter()
    {
        SceneManager.LoadScene("Main");
    }
}
