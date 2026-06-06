"""Local conftest for ipt_server kube pyunit tests.

Inserts the relocated ipt-server source tree into sys.path so that the live
daemon package (Config, ipt_server.*, route_config, etc.) is importable without
needing the repo-root tests/conftest.py.  Also re-exports REPO_ROOT for tests
that reference source files by repo-relative path.
"""

from pathlib import Path
import sys

# The ipt-server source lives at modules/ipt_server/kube/image/ipt-server
# relative to the repo root.  Compute REPO_ROOT as four parents up from this
# conftest (pyunit/ -> tests/ -> kube/ -> ipt_server/ -> modules/ -> repo root).
REPO_ROOT: Path = Path(__file__).resolve().parents[5]

_IPT_SERVER_SRC = REPO_ROOT / "modules" / "ipt_server" / "kube" / "image" / "ipt-server"
_ipt_server_src_str = str(_IPT_SERVER_SRC)
if _ipt_server_src_str not in sys.path:
    sys.path.insert(0, _ipt_server_src_str)
