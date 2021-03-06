
import * as React from "/Volumes/Oni 0.3.2/Oni.app/Contents/Resources/app/node_modules/react"
import * as Oni from "/Volumes/Oni 0.3.2/Oni.app/Contents/Resources/app/node_modules/oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

export const configuration = {
    //add custom config here, such as

    "ui.colorscheme": "nord",

    //"oni.useDefaultConfig": true,
    //"oni.bookmarks": ["~/Documents"],
    "oni.loadInitVim": true,
    "editor.fontFamily": "Menlo",
    "editor.fontSize": "13px",
    //"editor.fontFamily": "Monaco",

    // UI customizations
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",
    "autoClosingPairs.enabled": true,
    
    "commandline.mode": true,
}
