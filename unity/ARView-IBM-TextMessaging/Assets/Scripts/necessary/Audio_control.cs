using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Audio_control : MonoBehaviour
{

    [Header("Back Button Sound")]
    public AudioClip audio_clip_btn;

    [Header("AR Object Show Sound")]
    public AudioClip audio_clip_show;

    //Singleton pattern
    public static Audio_control instance;

    //Audio source
    private AudioSource audio_source;

    void Awake()
    {
        //Singleton pattern
        Audio_control.instance = this;
    }

    // Use this for initialization
    void Start()
    {
        //Find audio source
        this.audio_source = this.GetComponent<AudioSource>();
    }

    //Play back button sound
    public void play_btn_sound()
    {
        audio_source.PlayOneShot(this.audio_clip_btn, 0.3f);
    }

    //Play show sound
    public void play_show_sound()
    {
        audio_source.PlayOneShot(this.audio_clip_show, 1.5f);
    }
}
