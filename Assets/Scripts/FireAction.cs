using Planner;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireAction : Action
{
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
        // il laser active lo devo controllare nei prerequisiti? Come si ritorna lo stato?
        throw new System.NotImplementedException();
    }
}