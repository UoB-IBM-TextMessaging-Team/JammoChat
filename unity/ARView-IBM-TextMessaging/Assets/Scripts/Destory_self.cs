using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Destory_self : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GameObject.Destroy(this.gameObject, 5f);
    }
}
