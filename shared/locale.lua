-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LXR OIL CORPORATION - LOCALE SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
-- © 2026 iBoss21 / The Lux Empire | wolves.land
-- ═══════════════════════════════════════════════════════════════════════════════

Locale = {}
Locale.Phrases = {}
Locale.CurrentLanguage = Config.Lang or 'English'

-- ═══════════════════════════════════════════════════════════════════════════════
-- LOCALE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function Locale.Load(language)
    local phrases = {
        -- English Phrases
        English = {
            -- General
            oil_corporation = 'Oil Corporation',
            press_to_interact = 'Press ~INPUT_CONTEXT~ to interact',
            
            -- Oil Well
            place_oil_well = 'Place Oil Well',
            placing_oil_well = 'Placing oil well...',
            oil_well_placed = 'Oil well successfully placed!',
            oil_well_removed = 'Oil well removed!',
            max_oil_wells = 'You have reached the maximum number of oil wells!',
            insufficient_items = 'You don\'t have the required items!',
            
            -- Oil Well Menu
            interact_oil_well = 'Interact with Oil Well',
            check_status = 'Check Status',
            add_coal = 'Add Coal',
            destroy_oil_well = 'Destroy Oil Well',
            repair_oil_well = 'Repair Oil Well',
            
            -- Status
            oil_well_info = 'Oil Well #%s',
            owner = 'Owner: %s',
            quality = 'Quality: %s%%',
            coal_amount = 'Coal: %s / %s',
            
            -- Coal
            coal_added = 'Added %s coal to oil well!',
            coal_full = 'Oil well coal storage is full!',
            no_coal = 'You don\'t have any coal!',
            
            -- Repair
            repairing = 'Repairing oil well...',
            repair_complete = 'Oil well repaired to 100%% quality!',
            repair_cost = 'Repair Cost: $%s',
            cannot_afford_repair = 'You cannot afford this repair!',
            
            -- Barrels
            carry_barrel = 'Carry Barrel',
            drop_barrel = 'Drop Barrel',
            barrel_picked_up = 'Picked up barrel!',
            barrel_dropped = 'Dropped barrel!',
            sell_barrels = 'Sell Barrels',
            barrels_sold = 'Sold %s barrels for $%s!',
            no_barrels_to_sell = 'You don\'t have any barrels to sell!',
            
            -- Business
            open_business_menu = 'Open Business Menu',
            upgrade_business = 'Upgrade Business',
            business_upgraded = 'Business upgraded to %s!',
            manage_workers = 'Manage Workers',
            view_income = 'View Income Statistics',
            pay_rent = 'Pay Rent',
            rent_paid = 'Rent paid until %s',
            
            -- Workers
            hire_worker = 'Hire Worker',
            fire_worker = 'Fire Worker',
            worker_hired = 'Worker %s hired!',
            worker_fired = 'Worker %s fired!',
            max_workers = 'You have reached the maximum number of workers!',
            
            -- Missions
            accept_mission = 'Accept Mission',
            mission_accepted = 'Mission accepted: %s',
            mission_completed = 'Mission completed! Reward: $%s',
            mission_failed = 'Mission failed!',
            mission_active = 'You already have an active mission!',
            
            -- Errors
            error_occurred = 'An error occurred!',
            not_authorized = 'You are not authorized to do this!',
            too_far = 'You are too far away!',
            
            -- Confirmations
            confirm_destroy = 'Are you sure you want to destroy this oil well?',
            confirm_fire = 'Are you sure you want to fire this worker?'
        }
    }
    
    Locale.Phrases = phrases[language] or phrases['English']
end

function Locale.Get(key, ...)
    local phrase = Locale.Phrases[key] or key
    if ... then
        return string.format(phrase, ...)
    end
    return phrase
end

-- Shorthand function
function L(key, ...)
    return Locale.Get(key, ...)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LOAD LOCALE ON SCRIPT START
-- ═══════════════════════════════════════════════════════════════════════════════

Locale.Load(Locale.CurrentLanguage)
