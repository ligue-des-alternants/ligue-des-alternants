import type { Core } from '@strapi/strapi';

export default {
  /**
   * An asynchronous register function that runs before
   * your application is initialized.
   *
   * This gives you an opportunity to extend code.
   */
  register(/* { strapi }: { strapi: Core.Strapi } */) {},

  /**
   * An asynchronous bootstrap function that runs before
   * your application gets started.
   *
   * This gives you an opportunity to set up your data model,
   * run jobs, or perform some special logic.
   */
  async bootstrap({ strapi }: { strapi: Core.Strapi }) {
    // Configure public permissions for the News API
    const publicRole = await strapi
      .query('plugin::users-permissions.role')
      .findOne({ where: { type: 'public' } });

    if (publicRole) {
      // Get current permissions for the public role
      const existingPermissions = await strapi
        .query('plugin::users-permissions.permission')
        .findMany({
          where: {
            role: publicRole.id,
            action: {
              $in: ['api::news-item.news-item.find', 'api::news-item.news-item.findOne'],
            },
          },
        });

      // Only create permissions if they don't exist
      if (existingPermissions.length < 2) {
        const permissionsToCreate = [
          'api::news-item.news-item.find',
          'api::news-item.news-item.findOne',
        ];

        for (const action of permissionsToCreate) {
          const exists = existingPermissions.some((p) => p.action === action);
          if (!exists) {
            await strapi.query('plugin::users-permissions.permission').create({
              data: {
                action,
                role: publicRole.id,
              },
            });
            console.log(`✅ Created public permission for: ${action}`);
          }
        }
      }
    }
  },
};
