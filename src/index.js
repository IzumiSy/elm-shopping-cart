import { Elm } from "./App.elm"
import "./style.scss"

const app = Elm.App.init()

app.ports.loadOnLocalStorage.subscribe(() => {
  app.ports.loadedOnLocalStorage.send(JSON.parse(localStorage.getItem("ids")))
})

app.ports.persistOnLocalStorage.subscribe(ids => {
  localStorage.setItem("ids", JSON.stringify({ ids }))
})