async function loadPyodideAndModule() {
    var titleElement = document.getElementById("h2-head")
    var messageElement = document.getElementById("message1")
    let pyodide = await loadPyodide({indexURL : PYODIDE_FULL_URL})
    pyodide.globals.set("titleElement", titleElement)
    pyodide.globals.set("messageElement", messageElement)
    await pyodide.loadPackage("micropip")
    await pyodide.runPythonAsync(`
from importlib.metadata import version
import js
import micropip

async def install_mlog_extended() -> None:
    messageElement.innerText = "Loading mlog_extended..."
    await micropip.install(js.MLOG_EXTENDED_INSTALLTION)
    compiler_version = version("mlog_extended")
    titleElement.innerText += ", v" + compiler_version
    messageElement.innerText = "Loading complete!"

install_mlog_extended()
`)
    return pyodide
}
