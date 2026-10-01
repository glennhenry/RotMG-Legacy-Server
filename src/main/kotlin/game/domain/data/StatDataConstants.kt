@file:Suppress("unused")

package game.domain.data

object StatDataConstants {
    const val MAX_HP_STAT: Int = 0
    const val HP_STAT: Int = 1
    const val SIZE_STAT: Int = 2
    const val MAX_MP_STAT: Int = 3
    const val MP_STAT: Int = 4
    const val NEXT_LEVEL_EXP_STAT: Int = 5
    const val EXP_STAT: Int = 6
    const val LEVEL_STAT: Int = 7
    const val ATTACK_STAT: Int = 20
    const val DEFENSE_STAT: Int = 21
    const val SPEED_STAT: Int = 22
    const val INVENTORY_0_STAT: Int = 8
    const val INVENTORY_1_STAT: Int = 9
    const val INVENTORY_2_STAT: Int = 10
    const val INVENTORY_3_STAT: Int = 11
    const val INVENTORY_4_STAT: Int = 12
    const val INVENTORY_5_STAT: Int = 13
    const val INVENTORY_6_STAT: Int = 14
    const val INVENTORY_7_STAT: Int = 15
    const val INVENTORY_8_STAT: Int = 16
    const val INVENTORY_9_STAT: Int = 17
    const val INVENTORY_10_STAT: Int = 18
    const val INVENTORY_11_STAT: Int = 19
    const val VITALITY_STAT: Int = 26
    const val WISDOM_STAT: Int = 27
    const val DEXTERITY_STAT: Int = 28
    const val CONDITION_STAT: Int = 29
    const val NUM_STARS_STAT: Int = 30
    const val NAME_STAT: Int = 31
    const val TEX1_STAT: Int = 32
    const val TEX2_STAT: Int = 33
    const val MERCHANDISE_TYPE_STAT: Int = 34
    const val CREDITS_STAT: Int = 35
    const val MERCHANDISE_PRICE_STAT: Int = 36
    const val ACTIVE_STAT: Int = 37
    const val ACCOUNT_ID_STAT: Int = 38
    const val FAME_STAT: Int = 39
    const val MERCHANDISE_CURRENCY_STAT: Int = 40
    const val CONNECT_STAT: Int = 41
    const val MERCHANDISE_COUNT_STAT: Int = 42
    const val MERCHANDISE_MINS_LEFT_STAT: Int = 43
    const val MERCHANDISE_DISCOUNT_STAT: Int = 44
    const val MERCHANDISE_RANK_REQ_STAT: Int = 45
    const val MAX_HP_BOOST_STAT: Int = 46
    const val MAX_MP_BOOST_STAT: Int = 47
    const val ATTACK_BOOST_STAT: Int = 48
    const val DEFENSE_BOOST_STAT: Int = 49
    const val SPEED_BOOST_STAT: Int = 50
    const val VITALITY_BOOST_STAT: Int = 51
    const val WISDOM_BOOST_STAT: Int = 52
    const val DEXTERITY_BOOST_STAT: Int = 53
    const val OWNER_ACCOUNT_ID_STAT: Int = 54
    const val RANK_REQUIRED_STAT: Int = 55
    const val NAME_CHOSEN_STAT: Int = 56
    const val CURR_FAME_STAT: Int = 57
    const val NEXT_CLASS_QUEST_FAME_STAT: Int = 58
    const val LEGENDARY_RANK_STAT: Int = 59
    const val SINK_LEVEL_STAT: Int = 60
    const val ALT_TEXTURE_STAT: Int = 61
    const val GUILD_NAME_STAT: Int = 62
    const val GUILD_RANK_STAT: Int = 63
    const val BREATH_STAT: Int = 64
    const val XP_BOOSTED_STAT: Int = 65
    const val XP_TIMER_STAT: Int = 66
    const val LD_TIMER_STAT: Int = 67
    const val LT_TIMER_STAT: Int = 68
    const val HEALTH_POTION_STACK_STAT: Int = 69
    const val MAGIC_POTION_STACK_STAT: Int = 70
    const val BACKPACK_0_STAT: Int = 71
    const val BACKPACK_1_STAT: Int = 72
    const val BACKPACK_2_STAT: Int = 73
    const val BACKPACK_3_STAT: Int = 74
    const val BACKPACK_4_STAT: Int = 75
    const val BACKPACK_5_STAT: Int = 76
    const val BACKPACK_6_STAT: Int = 77
    const val BACKPACK_7_STAT: Int = 78
    const val HASBACKPACK_STAT: Int = 79
    const val TEXTURE_STAT: Int = 80
    const val PET_INSTANCEID_STAT: Int = 81
    const val PET_NAME_STAT: Int = 82
    const val PET_TYPE_STAT: Int = 83
    const val PET_RARITY_STAT: Int = 84
    const val PET_MAXABILITYPOWER_STAT: Int = 85
    const val PET_FAMILY_STAT: Int = 86
    const val PET_FIRSTABILITY_POINT_STAT: Int = 87
    const val PET_SECONDABILITY_POINT_STAT: Int = 88
    const val PET_THIRDABILITY_POINT_STAT: Int = 89
    const val PET_FIRSTABILITY_POWER_STAT: Int = 90
    const val PET_SECONDABILITY_POWER_STAT: Int = 91
    const val PET_THIRDABILITY_POWER_STAT: Int = 92
    const val PET_FIRSTABILITY_TYPE_STAT: Int = 93
    const val PET_SECONDABILITY_TYPE_STAT: Int = 94
    const val PET_THIRDABILITY_TYPE_STAT: Int = 95
    const val NEW_CON_STAT: Int = 96
    const val FORTUNE_TOKEN_STAT: Int = 97

    fun isStringStat(statData: Int): Boolean {
        return statData == NAME_STAT ||
                statData == GUILD_NAME_STAT ||
                statData == PET_NAME_STAT ||
                statData == ACCOUNT_ID_STAT ||
                statData == OWNER_ACCOUNT_ID_STAT
    }
}
