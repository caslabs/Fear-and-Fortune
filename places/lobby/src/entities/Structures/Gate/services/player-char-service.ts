import { OnStart } from "@flamework/core";
import { Component, BaseComponent } from "@flamework/components";
import { t } from "@rbxts/t";
import Make from "@rbxts/make";

interface Attributes {}

@Component({
	tag: "IronWoodTrigger",
	instanceGuard: t.instanceIsA("Model"),
})
export class IronWoodComponent extends BaseComponent<Attributes> implements OnStart {
	onStart() {
		print("IronWood Object Component Initiated");
	}
}
