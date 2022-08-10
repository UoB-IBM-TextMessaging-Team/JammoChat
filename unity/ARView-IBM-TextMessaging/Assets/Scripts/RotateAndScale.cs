using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAndScale : MonoBehaviour
{
    public float scaleRate;
    public float minScale, maxScale;
    public Camera cameraMain;
    private Camera cam;

    // Start is called before the first frame update
    void Start()
    {
        cam = cameraMain.GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        //Rotate
        if (Input.touchCount == 1)
        {
            Touch screenTouch = Input.GetTouch(0);

            if (screenTouch.phase == TouchPhase.Moved)
            {
                transform.Rotate(0f, -0.7f*screenTouch.deltaPosition.x, 0f);
            }

        }

        //Scale
        if (Input.touchCount == 2) {
            //Get position of touch
            Touch t0 = Input.GetTouch(0);
            Touch t1 = Input.GetTouch(1);
            //Get position of touch from previous frame
            Vector3 t0Pre = t0.position - t0.deltaPosition;
            Vector3 t1Pre = t1.position - t1.deltaPosition;

            float oldDistance = Vector3.Distance(t0Pre, t1Pre);
            float currentDistance = Vector3.Distance(t0.position, t1.position);

            //Get offset value
            float deltaDistance = oldDistance - currentDistance;
            zoom(deltaDistance, scaleRate);
        }

        if (cam.fieldOfView < minScale) {
            cam.fieldOfView = minScale;
        }
        else if (cam.fieldOfView > maxScale) {
            cam.fieldOfView = maxScale;
        }
        //Debug.Log(cam.fieldOfView);

    }

    void zoom(float deltaDistanceDiff, float rate) {
        cam.fieldOfView += deltaDistanceDiff * rate;
        //Set clamp for cam.fieldOfView
        cam.fieldOfView = Mathf.Clamp(cam.fieldOfView, minScale, maxScale);
    }
}
