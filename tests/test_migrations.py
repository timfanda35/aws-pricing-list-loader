from unittest.mock import MagicMock, patch

from app.migrations import run_migrations


def _make_mock_conn():
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_conn.__enter__ = MagicMock(return_value=mock_conn)
    mock_conn.__exit__ = MagicMock(return_value=False)
    mock_cursor.__enter__ = MagicMock(return_value=mock_cursor)
    mock_cursor.__exit__ = MagicMock(return_value=False)
    mock_conn.cursor.return_value = mock_cursor
    return mock_conn, mock_cursor


def test_run_migrations_creates_schema_migrations_table():
    mock_conn, mock_cursor = _make_mock_conn()
    mock_cursor.fetchall.return_value = []

    with patch("app.migrations.get_db_conn", return_value=mock_conn):
        with patch("app.migrations.MIGRATIONS_DIR") as mock_dir:
            mock_dir.glob.return_value = []
            run_migrations()

    executed_sqls = [c[0][0] for c in mock_cursor.execute.call_args_list]
    assert any("schema_migrations" in sql and "CREATE TABLE IF NOT EXISTS" in sql for sql in executed_sqls)


def test_run_migrations_applies_unapplied_files(tmp_path):
    (tmp_path / "0001_create_foo.sql").write_text("CREATE TABLE foo (id SERIAL PRIMARY KEY);")

    mock_conn, mock_cursor = _make_mock_conn()
    mock_cursor.fetchall.return_value = []

    with patch("app.migrations.get_db_conn", return_value=mock_conn):
        with patch("app.migrations.MIGRATIONS_DIR", tmp_path):
            run_migrations()

    executed_sqls = [c[0][0] for c in mock_cursor.execute.call_args_list]
    assert any("CREATE TABLE foo" in sql for sql in executed_sqls)
    assert any("INSERT INTO schema_migrations" in sql for sql in executed_sqls)


def test_run_migrations_skips_already_applied(tmp_path):
    (tmp_path / "0001_create_foo.sql").write_text("CREATE TABLE foo (id SERIAL PRIMARY KEY);")

    mock_conn, mock_cursor = _make_mock_conn()
    mock_cursor.fetchall.return_value = [("0001_create_foo.sql",)]

    with patch("app.migrations.get_db_conn", return_value=mock_conn):
        with patch("app.migrations.MIGRATIONS_DIR", tmp_path):
            run_migrations()

    executed_sqls = [c[0][0] for c in mock_cursor.execute.call_args_list]
    assert not any("CREATE TABLE foo" in sql for sql in executed_sqls)


def test_run_migrations_applies_files_in_order(tmp_path):
    (tmp_path / "0002_create_bar.sql").write_text("CREATE TABLE bar (id SERIAL PRIMARY KEY);")
    (tmp_path / "0001_create_foo.sql").write_text("CREATE TABLE foo (id SERIAL PRIMARY KEY);")

    mock_conn, mock_cursor = _make_mock_conn()
    mock_cursor.fetchall.return_value = []

    applied_order = []

    def capture_execute(sql, *args):
        if "CREATE TABLE foo" in sql or "CREATE TABLE bar" in sql:
            applied_order.append(sql)

    mock_cursor.execute.side_effect = capture_execute

    with patch("app.migrations.get_db_conn", return_value=mock_conn):
        with patch("app.migrations.MIGRATIONS_DIR", tmp_path):
            run_migrations()

    assert "foo" in applied_order[0]
    assert "bar" in applied_order[1]


def test_run_migrations_closes_connection():
    mock_conn, mock_cursor = _make_mock_conn()
    mock_cursor.fetchall.return_value = []

    with patch("app.migrations.get_db_conn", return_value=mock_conn):
        with patch("app.migrations.MIGRATIONS_DIR") as mock_dir:
            mock_dir.glob.return_value = []
            run_migrations()

    mock_conn.close.assert_called_once()
