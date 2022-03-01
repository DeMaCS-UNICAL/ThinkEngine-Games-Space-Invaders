using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SensorsGenerator : MonoBehaviour
{
    List<int> testingList = new List<int>();
    List<int> toAdd = new List<int>();
    int count = 0;
    // Update is called once per frame
    private void Start()
    {
        for (int i = 0; i < 1000; i++)
        {
            toAdd.Add(1);
        }
    }
    void Update()
    {
        if (++count % 250 ==0 && testingList.Count<100000)
        {
            testingList.AddRange(toAdd);
        }
    }
}
