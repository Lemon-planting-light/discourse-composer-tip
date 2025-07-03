import Component from "@glimmer/component";
import TagComposerTipItem from "./tag-composer-tip-item";

export default class TagComposerTip extends Component {
  get tagRules() {
    const tagSet = JSON.parse(settings.tag_and_descriptions_list);
    return tagSet;
  }

  <template>
    {{#each this.tagRules as |rule|}}
      <TagComposerTipItem @rule={{rule}} @model={{@outletArgs}} />
    {{/each}}
  </template>
}
