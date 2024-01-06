"use strict";

const populate = {
  fields: ["title", "description"],
  metadata: {
    populate: {
      metaImage: {
        populate: true,
        fields: ["url"],
      },
    },
  },
  blocks: {
    populate: {
      link: {
        populate: true,
      },
      image: {
        populate: true,
        fields: ["url"],
      },
      card: {
        populate: {
          image: {
            populate: true,
            fields: ["url"],
          },
        },
      },
      plan: {
        populate: ["services", "link"],
      },
      form: {
        populate: ["input", "button"],
      },
    },
  },
};

/**
 * `land-page-populate` middleware
 */
module.exports = (config, { strapi }) => {
  // Add your own logic here.
  return async (ctx, next) => {
    strapi.log.info("In land-page-populate middleware.");
    ctx.query = {
      populate,
      ...ctx.query,
    };
    await next();
  };
};
