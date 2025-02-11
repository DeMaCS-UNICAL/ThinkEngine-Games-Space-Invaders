using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class Projectile : MonoBehaviour
{
    public float speed = 20f;
    public Vector3 direction = Vector3.up;
    public System.Action<Projectile> destroyed;
    public new BoxCollider2D collider { get; private set; }
    
    public int increaseFactor;
    public int xLeft, xRight;

    private void Awake()
    {
        collider = GetComponent<BoxCollider2D>();
    }

    private void OnDestroy()
    {
        if (destroyed != null) {
            destroyed.Invoke(this);
        }
    }

    private void Update()
    {
        xLeft = (int)(transform.position.x * 1000 - 1000);
        xRight = (int)(transform.position.x * 1000 + 1000);
        increaseFactor = (int)((direction * speed * Time.deltaTime).y*1000);
        transform.position += direction * speed * Time.deltaTime;
        
        if (transform.position.y >= 15 || transform.position.y <= -15)
            Destroy(gameObject);
    }

    private void CheckCollision(Collider2D other)
    {
        Bunker bunker = other.gameObject.GetComponent<Bunker>();

        if (bunker == null || bunker.CheckCollision(collider, transform.position)) {
            Destroy(gameObject);
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        CheckCollision(other);
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        CheckCollision(other);
    }

}
