"use strict";

const { default: readingTime } = require("reading-time");

module.exports = {
  /**
   * An asynchronous register function that runs before
   * your application is initialized.
   *
   * This gives you an opportunity to extend code.
   */
  register(/*{ strapi }*/) {},

  /**
   * An asynchronous bootstrap function that runs before
   * your application gets started.
   *
   * This gives you an opportunity to set up your data model,
   * run jobs, or perform some special logic.
   */
  bootstrap({ strapi }) {
    // we listen to lifecycle events...
    strapi.db.lifecycles.subscribe({
      // only listen to events for type with this UID
      models: [],
      // after creating a new Admin
      async beforeCreate(data) {
        console.log(1);
        console.log(data);
        if (data.body) {
          data.readingTime =
            readingTime(data.body)?.text || null;
        }
      },


      async beforeUpdate(data) {
        console.log(2);
        console.log(data);
        if (data.body) {
          data.readingTime =
            readingTime(data.body)?.text || null;
        }
      },

        
      async afterUpdate(event) {
        console.log(2);
        console.log(event);
        // if (data.body) {
        //   data.readingTime =
        //     readingTime(data.body)?.text || null;
        // }
      },
    });
  },
};
