import sys

from app.migrations import run_migrations


def main():
    run_migrations()
    print("Migrations complete.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
