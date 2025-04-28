'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "daf53f5082d2ca04bae22b020936b443",
".git/config": "a7d798dbb5f76b78c21920f65c69172f",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "290eb976c3ca8bde8037a6ffd2d676fa",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d3118e8055ae8e85edf47017a30f73ae",
".git/logs/refs/heads/main": "d3118e8055ae8e85edf47017a30f73ae",
".git/logs/refs/remotes/origin/main": "553090cae972fb5a09b8bd38db9ba8e3",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/04/8f9e1a656705db8f66f6203902a34395e013b5": "2cd1f9d675c4427fd782913ee9dca6d0",
".git/objects/05/2507d7f61224f4b2060455850302ad90c305f4": "3e4a3367da22edbd15ddced881244e5f",
".git/objects/19/73e6e25428c0a3264d29bad3b6c65e08b0c35b": "70a6684e0595e89bbe64ab1a277689c0",
".git/objects/1d/c88178728f59cb8b1303bc308449928a173c3d": "2073e27b054fb4805f2226ee26a5b468",
".git/objects/26/f940f51b33b88b40e6503bc2d6651b3a27b24d": "9bd60cb9f0efce9e15f4534246d98e57",
".git/objects/33/31d9290f04df89cea3fb794306a371fcca1cd9": "e54527b2478950463abbc6b22442144e",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/41/7c31713c4bba1e151d36c74e8375f98d753d90": "72a1930fab187f842782943a23632879",
".git/objects/48/46537f1c1fcd9cccb06ae2d6ee87c6fed07843": "c31f3d1cc6b87c8b24b93553638eaf3e",
".git/objects/48/acb5e688f0a3a269290c21e300416a482a2dba": "e9c8256079dcc42bb38d672745ac8609",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/50/11dad0e9caa4d6e16765bfdf45139d9723eeff": "d489552c1f7c99a9b49c0bed3fffebd2",
".git/objects/54/a211c91e11e9594395d4814fcd1a03b103fbb6": "71f4cb7987e09628e9f662c0efe7435a",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/5e/bf37944a56f2b5e479e3858392c6e9030da2da": "d874f5ce1eb6512c7b77ebd17b676f00",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/64/5116c20530a7bd227658a3c51e004a3f0aefab": "f10b5403684ce7848d8165b3d1d5bbbe",
".git/objects/6a/cdc647ede609687ede2d6a989271bc01ba6920": "29b1d4ad423cd878b3dd37e6ada7a4db",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/7514aabf9776a5f3655ba426ebb1d8e80ce73f": "d1c5e14b6be2b11d3e88eaa052e3fe30",
".git/objects/7e/3bb2f8ce7ae5b69e9f32c1481a06f16ebcfe71": "4ac6c0fcf7071bf9fc9c013172f9996f",
".git/objects/85/24afc186b03e3a6528d5965d3233ceefb50689": "f81f79e8d433dfb184efce56b3cd546a",
".git/objects/86/5b24a0bcdc135d9c43ace953a71c8e82c64581": "721250a3ffca5750bb1cf528b8573b7d",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/90/2a5f301f0d6d4c61449c704d48a4b3ed18d87e": "cdd69b5746ac0d99fdf093ca3a64c3fc",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/93/be7fd9b9dcdd8564dafd7040a0c8c8f68d4080": "b27ff257c793a735fc818ff37f392ff9",
".git/objects/9d/7cf220f98402e6908795046cd3c124886fc54a": "2fe461ce38db262ea17658f27acd3579",
".git/objects/a0/3cfc240255b3c7834482921aee89bd7a5c206e": "efe6e093bcde2011598643714c5c79b1",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a6/3e4eb1683cf9f926187dc812a19f28af005c2e": "30586a4ebc2dd76fddb7ec50a4eeeb8e",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/a9/237b32b4ae7ba14bafe9fd346ce9b1c4329c9f": "76b410ae564e1f57a60fa2a869204126",
".git/objects/aa/7577f3955a2a5c3da5c67d4e26267242d154cf": "9b9d94a25045bbdce4184e193190937f",
".git/objects/ac/28c3365ed0d28b8f86ab3010d69b5b01653c96": "d368f22df9444159eae191443df502d7",
".git/objects/b3/e2a3aa67924d2fe1695b15c7cbf424c9fbcff5": "f54ff66da11de5b9f23cd2007e8a2f52",
".git/objects/bf/2ae734b24d487686ae5b2e5006244ac4bac317": "bc7c36a3c57949f0515dee8cbd2e1615",
".git/objects/bf/815f742520dac5c0dd315a35d946753b003f54": "1ea10393a147013e7c392bd398c95fb6",
".git/objects/c3/abaefb284004df30fc3017c7fa7985b412405d": "d933c20829aeab2af7aef2ea8dad1a69",
".git/objects/c3/ec5866f7477df6a0201c4cd765ace33f02d854": "9affef597b8caf8b06a181bdc8614b2e",
".git/objects/c6/167099830a8a84c2a05bed643f5b7771f7f6e3": "fbbdafde62078d2ad71ab795586dd774",
".git/objects/c9/4f2a5715c7055b359543e5337e5c9a39c6a8a6": "7dbdede0b8d108aea6eb30b65818a377",
".git/objects/ca/6da829edec78c81617bbaf220c15b133c28d87": "1c61ba907b6ed3cf58a028f8c0ee2b89",
".git/objects/ce/a5f2f1a48b3c529dc04f31b4df48e4e2876865": "c36a34a375fac78ab51cd2d335872873",
".git/objects/ce/e3c5bb4ad9ca1b7e02e3391cc1cbba998308b7": "8e23cc0d8eea61c17a30b19ec3ccb417",
".git/objects/cf/5dac87e54d0cc54c826a877a4ffa6d503cd4fc": "4ac7c8ff170168d12c1a9e447f978f42",
".git/objects/d2/35efdeb1b12b4fe284ac278dd8b4c19eafe223": "daae56db5fee9cacdf04333f417bff77",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/d9/f5ae1415d8b2b925aed6ff031ba18b5bbf872a": "b0689dc39e77bfcaf48e1b8389cc7b9e",
".git/objects/df/35c27c04a6c596da30c9ef6c4cfcba3a397ed1": "f4df8731dcd64f53f8d5f9c986844891",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/9ff3ac285e0d5378dd4105fc2da02501ae418e": "dcb11ce96716c66452e409f9f70141d8",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f1/071f00ff9fc65d266071b1a2b0feeae0d5e186": "cf0957a41b8d951bbdf098d982baecff",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/6faeee77e396c82cdbe8a54fa32281ee39a690": "2e11eecf1236ff990cad9798043d1375",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/refs/heads/main": "5741133c5b1fc6e16ed04ae5e9b44459",
".git/refs/remotes/origin/main": "5741133c5b1fc6e16ed04ae5e9b44459",
"assets/AssetManifest.bin": "581ee7a2a584897241ae5e06ce5abae9",
"assets/AssetManifest.bin.json": "80c211c5bb44b657c186f01aaef28384",
"assets/AssetManifest.json": "ba81600499891aa02d757382af1548a4",
"assets/assets/eula.txt": "e3829533e53359a1503b78a1324d0770",
"assets/assets/faq.txt": "5f17738018ff282e340cc37769066479",
"assets/assets/fonts/Roboto-Bold.ttf": "8c9110ec6a1737b15a5611dc810b0f92",
"assets/assets/fonts/Roboto-Italic.ttf": "1fc3ee9d387437d060344e57a179e3dc",
"assets/assets/fonts/Roboto-Regular.ttf": "303c6d9e16168364d3bc5b7f766cfff4",
"assets/assets/logo.png": "62ff5a3c05e41b5b9eeb7cc77cff899a",
"assets/assets/policies/eula.txt": "fa6bca5e687cc5e9812afc5c86aee2c8",
"assets/assets/policies/faq.txt": "eedf8d28d389df006e47f2040f669c52",
"assets/assets/policies/privacy-policy.txt": "d04ab0be76ef7f3ced7a122c19c66ab7",
"assets/assets/policies/terms-of-service.txt": "97047a3f7e812d194dc158c844337fea",
"assets/FontManifest.json": "883a1cff32a038e4a404714f92eb1c2d",
"assets/fonts/MaterialIcons-Regular.otf": "71137f12cde923d785e1e4901bade6b5",
"assets/NOTICES": "6b27b58f8f2e23cacbe33e92d45c05dc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "204abfa304843009543d1bfb6b1e380b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "7cc3a60a5feb02ba7be2fd458e00d008",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "e2c687942714542a8dc176997a6926e7",
"icons/Icon-192.png": "712e1cd464bed86a6ceb7b35c9f68d1c",
"icons/Icon-512.png": "f776c977d23a82469890c488f82cc0a4",
"icons/Icon-maskable-192.png": "712e1cd464bed86a6ceb7b35c9f68d1c",
"icons/Icon-maskable-512.png": "f776c977d23a82469890c488f82cc0a4",
"index.html": "e24ded0781f697e56b756d163efff7d4",
"/": "e24ded0781f697e56b756d163efff7d4",
"main.dart.js": "5cd4923715399302b7db2e169655c282",
"manifest.json": "312d03a2ba5ec3c4ab61d4759bea9676",
"version.json": "55a3064654fe480fbb9de32663a4aa92"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
