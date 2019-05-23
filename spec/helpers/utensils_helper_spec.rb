require 'rails_helper'

RSpec.describe UtensilsHelper, type: :helper do
  describe 'button modal utensil' do
    it 'render partial' do
      allow(helper).to receive(:render)
      assign(:utensil, Utensil.new)
      helper.button_modal_utensil("#some_target_id", "some value", "some_id")      
      expect(helper).to have_received(:render).with(partial: "button_modal", locals: { id: "some_id", target_id: "#some_target_id", value: "some value"})      
    end

    it 'render utensil new' do
      assign(:utensil, Utensil.new)
      resp = helper.button_modal_utensil("#some_target_id", "some value", "some_id")      
      expect(resp).to include('data-test="button-modal"')
    end


  end
end
