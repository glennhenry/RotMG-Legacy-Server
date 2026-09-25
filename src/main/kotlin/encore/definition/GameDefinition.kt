package encore.definition

/**
 * Describes game rules, policies, and static data.
 *
 * A `GameDefinition` encapsulates the data and logic that describe
 * how a particular domain of the game behaves.
 *
 * Examples:
 * - `BossConfig` may define boss levels, HP, and EXP.
 * - `BossSpawnRules` may provide methods like `getBossesFor(zoneId)`.
 * - `BuildingLevels` may describe upgrade paths and perks.
 *
 * Instances are typically produced from a [GameDataSource]
 * via a corresponding [GameDataLoader].
 *
 * See example `encoreTest.definition.GameReferenceTest`.
 */
interface GameDefinition
