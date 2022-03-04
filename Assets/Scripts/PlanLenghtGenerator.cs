using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlanLenghtGenerator : MonoBehaviour
{
    int n=10;
    int frame = 0;

    // Update is called once per frame
    void Update()
    {
        frame++;
        if (frame % (2*n) == 0)
        {
            frame = 0;
            n *= 5;
        }
    }
}
