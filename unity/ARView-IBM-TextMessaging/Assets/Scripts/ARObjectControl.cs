using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ARObjectControl : MonoBehaviour
{
    public GameObject arCharacter;
    public Transform aimTarget;
   
    private Animator animator;
    private CharacterSkinController skinControl;
    
    public Animator Animator { get { return animator; } }
    public CharacterSkinController CharacterSkinController { get { return skinControl; } }
    private void Awake()
    {
        animator = arCharacter.GetComponent<Animator>();
        skinControl = arCharacter.GetComponent<CharacterSkinController>();
    }

    void OnEnable()
    {
       
        Vector3 camPos = Camera.main.transform.position;
        camPos.y = arCharacter.transform.position.y;
        Vector3 forward = camPos - arCharacter.transform.position;
        arCharacter.transform.rotation = Quaternion.LookRotation(forward, Vector3.up);
        arCharacter.GetComponent<Animator>().SetTrigger("jump");
        //Play show sound later
        //Invoke("play_particle_and_audio", 0.2f);
    }


    private void Update()
    {
        aimTarget.position = Camera.main.transform.position;
    }

    /*
    //Play show sound
    private void play_particle_and_audio()
    {
        Audio_control.instance.play_show_sound();
    }
    */
  
}
