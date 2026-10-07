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
        httpSafePort:  __PORT_SOCKET__,
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
            port: 3010, // Public http and websocket port
        },
        {
            host: "127.0.0.1",
            port: 3011,
        }
    ],
    "core": [
        {
            host: "127.0.0.1",
            port: 3020, // Internal websocket between all nodes
        },
        {
            host: "127.0.0.1",
            port: 3021,
        }
    ],
    "storage": [
        {
            host: "127.0.0.1",
            port: 3030, // Public port to serve "blob", "block", etc.
            wsPort: 3040, // Internal websocket between storage nodes
        },
        {
            host: "127.0.0.1",
            port: 3031,
            wsPort: 3041,
        }
    ]
};
