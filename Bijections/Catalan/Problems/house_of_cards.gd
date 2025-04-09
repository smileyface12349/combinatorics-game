extends CatalanProblemDerived
class_name CatalanHouseOfCards

func _init() -> void:
    super(
        "House of Cards",
        "House of Cards with n cards on the bottom level",
        6,
		{
			5: CatalanBijection.new(
				"Draw a line across the top to form a Schroder path",
				func to_schroder_path(house_of_cards: HouseOfCardsElement) -> SchroderPathElement:
                    # TODO
                    return SchroderPathElement.new([], house_of_cards.id),
				"TODO",
				2
			)
		},
		[DefinitionDyckPath.new()]
	)
