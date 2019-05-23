# frozen_string_literal: true

# Utensils helper
module UtensilsHelper
  def button_modal_utensil(target_id, value, id)
    render partial: 'button_modal', locals: { target_id: target_id, value: value, id: id }
  end
end
