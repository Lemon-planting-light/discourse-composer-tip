import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import TagTipModal from "./tag-composer-tip-modal";

export default class TagComposerTipItem extends Component {
  @service currentUser;
  @service modal;
  @service appEvents;

  @tracked tick = null;

  constructor() {
    super(...arguments);
    this.appEvents.on("tag-composer-tip:composer-updated", () => {
      this.tick = Math.random();
    });
  }

  get composer() {
    return this.args.model?.composer;
  }

  get topic() {
    return this.composer?.topic;
  }

  get shouldRender() {
    if (this.tick == null) {
      // do nothing;
    }
    if (!this.currentUser) {
      return false;
    }
    if (!this.composer) {
      return false;
    }
    if (!this.topic) {
      return false;
    }
    if (
      !this.topic?.tags?.includes(this.args.rule.tag_name) &&
      !this.composer?.tags?.includes(this.args.rule.tag_name)
    ) {
      return false;
    }
    if (
      this.args.rule.hide_for_OP &&
      this.topic?.user_id === this.currentUser?.id
    ) {
      return false;
    }
    if (this.args.rule.hide_for_replyer && this.topic?.posted) {
      return false;
    }
    return true;
  }

  get showModalInsteadOfSummary() {
    return settings.show_modal_instead_of_summary;
  }

  @action
  showModal() {
    this.modal.show(TagTipModal, {
      model: {
        title: this.args.rule.short_description,
        text: this.args.rule.long_description,
      },
    });
  }

  <template>
    {{#if this.shouldRender}}
      {{#if this.showModalInsteadOfSummary}}
        <button
          class="tag-composer-tip-btn btn btn-link"
          {{on "click" this.showModal}}
        >
          {{this.args.rule.short_description}}
        </button>
      {{else}}
        <details class="tag-composer-tip-item">
          <summary>
            {{this.args.rule.short_description}}
          </summary>
          <span>
            {{htmlSafe this.args.rule.long_description}}
          </span>
        </details>
      {{/if}}
    {{/if}}
  </template>
}
