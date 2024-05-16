module MicropostsHelper
  def relationship_with user
    current_user.active_relationships.find_by(followed_id: user.id)
  end
end
