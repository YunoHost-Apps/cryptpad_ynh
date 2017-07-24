/*
    globals module
*/
module.exports = {

    // the address you want to bind to, :: means all ipv4 and ipv6 addresses
    // this may not work on all operating systems
    httpAddress: '::',

    // the port on which your httpd will listen

    /*  Cryptpad can be configured to send customized HTTP Headers
     *  These settings may vary widely depending on your needs
     *  Examples are provided below
     */

    httpHeaders: {
        "X-XSS-Protection": "1; mode=block",
        "X-Content-Type-Options": "nosniff",
        // 'X-Frame-Options': 'SAMEORIGIN',
    },

    contentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'",
        "script-src 'self'",
        "font-src 'self'",

        /*  child-src is used to restrict iframes to a set of allowed domains.
         *  connect-src is used to restrict what domains can connect to the websocket.
         *
         *  it is recommended that you configure these fields to match the
         *  domain which will serve your cryptpad instance.
         */
        "connect-src 'self' ws://* wss://*",
        "child-src 'self' *",

        // data: is used by codemirror
        "img-src 'self' data:",
    ].join('; '),

    // CKEditor requires significantly more lax content security policy in order to function.
    padContentSecurity: [
        "default-src 'none'",
        "style-src 'unsafe-inline' 'self'",
        // Unsafe inline, unsafe-eval are needed for ckeditor :(
        "script-src 'self' 'unsafe-eval' 'unsafe-inline'",
        "font-src 'self'",

        /*  See above under 'contentSecurity' as to how these values should be
         *  configured for best effect.
         */
         "child-src 'self' *",
         "connect-src 'self' ws://* wss://*",

        // (insecure remote) images are included by users of the wysiwyg who embed photos in their pads
        "img-src *",
    ].join('; '),

    httpPort: __PORT__,

    /*  your server's websocket url is configurable
     *  (default: '/cryptpad_websocket')
     *
     *  websocketPath can be relative, of the form '/path/to/websocket'
     *  or absolute, specifying a particular URL
     *
     *  'wss://cryptpad.fr:3000/cryptpad_websocket'
     */
    websocketPath: '/cryptpad_websocket',

    /*  it is assumed that your websocket will bind to the same port as http
     *  you can override this behaviour by supplying a number via websocketPort
     */
    //websocketPort: 3000,

    /*  if you want to run a different version of cryptpad but using the same websocket
     *  server, you should use the other server port as websocketPort and disable
     *  the websockets on that server
     */
    //useExternalWebsocket: false,

    /*  If Cryptpad is proxied without using https, the server needs to know.
     *  Specify 'useSecureWebsockets: true' so that it can send
     *  Content Security Policy Headers that prevent http and https from mixing
     */
     useSecureWebsockets: false,

    /*  Cryptpad can log activity to stdout
     *  This may be useful for debugging
     */
    logToStdout: false,

    /*  Cryptpad supports verbose logging
     *  (false by default)
     */
     verbose: false,

    /*  Main pages
     *  add exceptions to the router so that we can access /privacy.html
     *  and other odd pages
     */
    mainPages: [
        'index',
        'privacy',
        'terms',
        'about',
        'contact',
    ],

    /*
        You have the option of specifying an alternative storage adaptor.
        These status of these alternatives are specified in their READMEs,
        which are available at the following URLs:

        mongodb: a noSQL database
            https://github.com/xwiki-labs/cryptpad-mongo-store
        amnesiadb: in memory storage
            https://github.com/xwiki-labs/cryptpad-amnesia-store
        leveldb: a simple, fast, key-value store
            https://github.com/xwiki-labs/cryptpad-level-store
        sql: an adaptor for a variety of sql databases via knexjs
            https://github.com/xwiki-labs/cryptpad-sql-store

        For the most up to date solution, use the default storage adaptor.
    */
    storage: './storage/file',
    //{
    //storage: 'cryptpad-level-store',
    //levelPath: './datastore.db',
    //},
    /*
        Cryptpad stores each document in an individual file on your hard drive.
        Specify a directory where files should be stored.
        It will be created automatically if it does not already exist.
    */
    filePath: './datastore/',

    /*  Cryptpad's file storage adaptor closes unused files after a configurale
     *  number of milliseconds (default 30000 (30 seconds))
     */
    channelExpirationMs: 30000,

    /*  Cryptpad's file storage adaptor is limited by the number of open files.
     *  When the adaptor reaches openFileLimit, it will clean up older files
     */
    openFileLimit: 2048,

    /*  Cryptpad's socket server can be extended to respond to RPC calls
     *  you can configure it to respond to custom RPC calls if you like.
     *  provide the path to your RPC module here, or `false` if you would
     *  like to disable the RPC interface completely
     */
    rpc: './rpc.js',

    /*  RPC errors are shown by default, but if you really don't care,
     *  you can suppress them
     */
    suppressRPCErrors: false,

    /* it is recommended that you serve cryptpad over https
     * the filepaths below are used to configure your certificates
     */
    //privKeyAndCertFiles: [
    //  '/etc/apache2/ssl/my_secret.key',
    //  '/etc/apache2/ssl/my_public_cert.crt',
    //  '/etc/apache2/ssl/my_certificate_authorities_cert_chain.ca'
    //],
};
