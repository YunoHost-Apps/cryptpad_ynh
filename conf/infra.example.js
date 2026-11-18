// SPDX-FileCopyrightText: 2026 XWiki CryptPad Team <contact@cryptpad.org> and contributors
//
// SPDX-License-Identifier: AGPL-3.0-or-later

module.exports = {
    "public": {
        // Public URL of the instance (used for Content-Security-Policy)
        origin: "https://__DOMAIN__",
        // Sandbox URL of the instance
        sandboxOrigin: "https://__SANDBOXDOMAIN__",
        // Address and port of the nodejs HTTP server
        httpHost: "127.0.0.1",
        httpPort: __PORT__,
        //httpSafePort: 3001,
        // (Optional) API server URL if hosted on a different domain (ws and http)
        externalWebsocketURL: undefined,
        fileHost: undefined,
        // (Optional) httpServerId only useful for multi-server cases
        httpServerId: "",
    },
    // Configure the topology here. Add or remove nodes on each level
    // depending on your instance usage.
    // "host" and "port" correspond to the nodejs HTTP server of each node
    // "url" is optional and can be set if your nodes are on different machines.
    // They must be able to reach each other from this URL
    // "serverId" is optional and is only useful for multi-server cases
    "front": [
        {
            host: "127.0.0.1",
            port: __PORT__, // Public http and websocket port
        }
    ],
    "core": [
        {
            host: "127.0.0.1",
            port: __PORT__, // Internal websocket between all nodes
        }
    ],
    "storage": [
        {
            host: "127.0.0.1",
            port: __PORT__, // Public port to serve "blob", "block", etc.
            wsPort: __PORT_SOCKET__, // Internal websocket between storage nodes
        }
    ]
};
