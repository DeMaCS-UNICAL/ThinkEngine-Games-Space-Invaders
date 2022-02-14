using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntPair : MonoBehaviour
{
    int x;
    int y;

    private void Update()
    {
        x = (int)transform.position.x;
        y = (int)transform.position.y;
    }
}
