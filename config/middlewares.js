module.exports = [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  'strapi::cors',
  // {
  //   name:'strapi::cors',
  //   config:{
  //     origin:['http://localhost:4321'], //允许访问的源
  //     methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'],
  //     headers: ['Content-Type', 'Authorization', 'Origin', 'Accept'],
  //     keepHeaderOnError: true,
  //   }
  // },
  'strapi::poweredBy',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',

];
