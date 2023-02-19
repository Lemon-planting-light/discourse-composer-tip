/* eslint-disable no-console */
import { withPluginApi } from "discourse/lib/plugin-api";
import showModal from "discourse/lib/show-modal";
import DiscourseURL from "discourse/lib/url";

export default {
  name: "functional-tags-tips-in-composer",
  initialize() {
    withPluginApi("1.4.0", (api) => {
      const curUser = api.getCurrentUser();
      if (!curUser) {return;}
      const tagSet = JSON.parse(settings.tag_and_descriptions_list);

      function editTopicTagDescription(model) {
        // console.log(model);
        try {
          const topicTags = model?.topic?.tags;
          if (topicTags) {
            for (const rule of tagSet) {
              if (topicTags.includes(rule.tag_name)) {
                if (rule.hide_for_OP && model?.topic?.user_id === curUser?.id) {continue;}
                if (rule.hide_for_replier && model?.topic?.posted) {continue;}
                if (settings.show_modal_instead_of_summary) {
                  const tip = document.getElementById("topic-tag-desc");
                  const btn = document.createElement('a');
                  btn.innerText = rule.short_description;
                  btn.onclick = () => showModal("composer-tag-tip", {
                    model: {
                      title: rule.short_description,
                      text: rule.long_description
                    }
                  });
                  tip.innerHTML = ``;
                  console.log(tip.appendChild(btn));
                } else {
                  const txt = `
                  <details>
                  <summary>
                  ${rule.short_description}
                  </summary>
                  <span>
                  ${rule.long_description}
                  </span>
                  </details>
                  `;
                  const tip = document.getElementById("topic-tag-desc");
                  tip.innerHTML = txt;
                  for (const link of tip.getElementsByTagName("a")) {
                    link.onclick = () => DiscourseURL.routeTo(link.href);
                  }
                }
                return true;
              }
            }
          }
          const txt = ``;
          document.getElementById("topic-tag-desc").innerHTML = txt;
          return true;
        } catch (err) {
          console.log(err);
          return false;
        }
      }

      function makeSure(func, Times = 0) {
        if (func() === false) {
          if (Times < 10) {setTimeout(() => makeSure(func, Times + 1), 200);}
        } else {
          if (Times < 3) {setTimeout(() => makeSure(func, Times + 1), 200 + 100 * Times);}
        }
      }

      api.customizeComposerText({
        actionTitle(model) {
          setTimeout(() => makeSure(() => editTopicTagDescription(model)), 100);
          return undefined;
        },
      });
    });
  },
};
