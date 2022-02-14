using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Example : Action
{
    int bla { get; set; }
    public override void Do()
    {
        FindObjectOfType<Player>().Shoot();
        throw new System.NotImplementedException();
    }

    public override bool Done()
    {
        return true;
    }

    public override State Prerequisite()
    {
        throw new System.NotImplementedException();
    }
}
