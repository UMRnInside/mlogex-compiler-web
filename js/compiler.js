async function globalPyodidePromise() {
    pyodide = await loadPyodideAndModule()
}

function compile() {
    srcArea = document.getElementById("source-code-area")
    dstArea = document.getElementById("destination-code-area")
    msgArea = document.getElementById("message1")
    console.log(pyodide.runPython)
    pyodide.runPython(`
import js
from mlog_extended import ExtendedCompiler, CompilationError
compiler = ExtendedCompiler()

try:
    js.msgArea.innerText = "Compiling..."
    src = js.srcArea.value
    result = compiler.compile(src)
    js.dstArea.value = result
except CompilationError as e:
    js.msgArea.innerText = e.args[0]
except ValueError:
    js.msgArea.innerText = "Internal error or wrong kwarg format!"
except:
    js.msgArea.innerText = "Internal error"
else:
    js.msgArea.innerText = "Success!"
`)
}

globalPyodidePromise()
