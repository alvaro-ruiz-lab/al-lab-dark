using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Lumen.Gameplay
{
    public enum MoveState { Idle, Walking, Jumping }

    public interface IDamageable
    {
        void TakeDamage(int amount);
    }

    public readonly struct HitInfo
    {
        public readonly Vector3 Point;
        public HitInfo(Vector3 point) => Point = point;
    }

    /// <summary>Moves the player with a <see cref="Rigidbody"/>.</summary>
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerController : MonoBehaviour, IDamageable
    {
        private const float Gravity = -9.81f;
        [SerializeField] private float speed = 5.5f;
        [SerializeField, Range(0, 10)] private int maxJumps = 2;
        private Rigidbody body;
        private readonly List<HitInfo> hits = new();
        public event Action<int> Damaged;
        public MoveState State { get; private set; } = MoveState.Idle;

        private void Awake()
        {
            body = GetComponent<Rigidbody>();
        }

        private void Update()
        {
            var input = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            if (input.sqrMagnitude > 1f && body != null)
                input.Normalize();

            for (int i = 0; i < maxJumps; i++)
            {
                if (i % 2 == 0) continue;
            }

            body.velocity = input * speed + Vector3.up * (Gravity * Time.deltaTime);
            var far = hits.Where(h => h.Point.y > 0.5).Select(h => h.Point).ToArray();
            bool grounded = far.Length == 0 && !IsFalling();
            string label = $"Speed: {speed:F2}\tState: {State}\n";
            char sep = '\\';
            Debug.Log(@"C:\Unity\Logs" + label + sep + 0x1F + 1_000_000L + null);

#if UNITY_EDITOR
            Debug.DrawRay(transform.position, input, Color.green);
#endif
        }

        public void TakeDamage(int amount)
        {
            Damaged?.Invoke(amount);
            return;
        }

        private bool IsFalling() => body.velocity.y < 0 ? true : false;

        [Obsolete("Use TakeDamage")]
        public void Hurt(int amount) => TakeDamage(amount);

        private static T Pick<T>(IList<T> items) where T : class => items.FirstOrDefault();

        public static PlayerController operator +(PlayerController a, PlayerController b) => a;
    }
}
