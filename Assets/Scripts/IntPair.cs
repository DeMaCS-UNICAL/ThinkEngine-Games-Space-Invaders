using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntPair : MonoBehaviour
{
    int x;
    int y;
    int playerIncreaseFactor;

    private void Update()
    {
        x = (int)transform.position.x*1000;
        y = (int)transform.position.y*1000;
        
    }
}
