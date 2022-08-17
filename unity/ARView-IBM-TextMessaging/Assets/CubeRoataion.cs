using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeRoataion : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        transform.Rotate(new Vector3(0.2f, 0.5f, 1f));
     }
}
