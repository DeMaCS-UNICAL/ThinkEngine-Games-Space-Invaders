using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SensorsGenerator : MonoBehaviour
{
    List<int> testingList = new List<int>();
    int count = 0;
    // Update is called once per frame
    private void Start()
    {
        testingList.Add(1);
    }
    void Update()
    {
        if (++count % 50 ==0 && testingList.Count<1000)
        {
            testingList.AddRange(testingList);
        }
    }
}
