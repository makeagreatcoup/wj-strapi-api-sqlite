// "use strict"

// module.exports = {
//   lifecycles: {
//     async beforeCreate(data) {
//       console.log(1);
//       console.log(data);
//       if (data.body) {
//         data.readingTime = readingTime(data.body)?.text || null;
//       }
//     },

//     async beforeUpdate(data) {
//       console.log(2);
//       console.log(data);
//       if (data.body) {
//         data.readingTime = readingTime(data.body)?.text || null;
//       }
//     },
//   },
//   async beforeCreate(event) {
//     console.log(3);
//     console.log(event);
//     if (event.params.data.body) {
//       event.params.data.readingTime =
//         readingTime(event.params.data.body)?.text || null;
//     }
//   },

//   async beforeUpdate(event) {
//     console.log(4);
//     console.log(event);
//     if (event.params.data.body) {
//       event.params.data.readingTime =
//         readingTime(event.params.data.body)?.text || null;
//     }
//   },
// };
