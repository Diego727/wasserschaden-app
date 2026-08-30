// Wasserschaden V2: alter Offline-Cache wird absichtlich entfernt.
self.addEventListener('install',event=>{self.skipWaiting()});
self.addEventListener('activate',event=>{event.waitUntil((async()=>{for(const key of await caches.keys())if(key.startsWith('wasserschaden-'))await caches.delete(key);await self.registration.unregister();const clientsList=await self.clients.matchAll({type:'window'});for(const client of clientsList)client.navigate(client.url)})())});
