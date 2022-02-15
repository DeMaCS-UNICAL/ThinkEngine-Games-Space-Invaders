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
        //DENISE: non serve controllare il laser active, al massimo gli dici di sparare anche se sta già sparando;
        //per ritornare lo stato basta fare State.WAIT/State.ABORT/State.READY
        throw new System.NotImplementedException();
    }
}