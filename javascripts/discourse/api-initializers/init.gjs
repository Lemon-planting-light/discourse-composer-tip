import { apiInitializer } from "discourse/lib/api";
import TagComposerTip from "../components/tag-composer-tip";

export default apiInitializer((api) => {
  api.renderInOutlet("after-d-editor", TagComposerTip);
  api.customizeComposerText({
    actionTitle() {
      api.container
        .lookup("service:appEvents")
        .trigger("tag-composer-tip:composer-updated");
      return undefined;
    },
  });
});
