using UnityEngine;

public class Player : MonoBehaviour
{
    public float speed = 5f;
    public Projectile laserPrefab;
    public System.Action killed;

    public int increaseFactor;
    public string previousDirection = "left";
    public bool laserActive { get; private set; }

    private void Update()
    {
        increaseFactor = (int)(Time.deltaTime * 5 * 1000);
        string move = "";
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
            move = "right";
        else if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
            move = "left";
        Move(move);

        if (Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0)) {
            Shoot();
        }
    }

    internal void Shoot()
    {
        // Only one laser can be active at a given time so first check that
        // there is not already an active laser
        if (!laserActive || GameObject.Find("Laser(Clone)") == null)
        {
            laserActive = true;

            Projectile laser = Instantiate(laserPrefab, transform.position, Quaternion.identity);
            laser.destroyed += OnLaserDestroyed;
        }
    }
    internal void Move(string move)
    {
        Vector3 position = transform.position;
        if (move=="left")
        {
            position.x -= speed * Time.deltaTime;
        }
        else if (move=="right")
        {
            position.x += speed * Time.deltaTime;
        }

        Vector3 leftEdge = Camera.main.ViewportToWorldPoint(Vector3.zero);
        Vector3 rightEdge = Camera.main.ViewportToWorldPoint(Vector3.right);

        // Clamp the position of the character so they do not go out of bounds
        position.x = Mathf.Clamp(position.x, leftEdge.x, rightEdge.x);
        transform.position = position;

    }


    private void OnLaserDestroyed(Projectile laser)
    {
        laserActive = false;
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("Missile") ||
            other.gameObject.layer == LayerMask.NameToLayer("Invader"))
        {
            if (killed != null) {
                killed.Invoke();
            }
        }
    }


}
