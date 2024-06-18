#!/bin/bash

## Configuration
API_KEY="your_api_key_here"  # Replace with your actual API key
CHARACTER_NAME="Character Name"  # Replace with your character's name
ACCOUNT_NAME="Account.1234"  # Replace with your account name

## Functions
get_json() {
    curl -s -X$1 -H "Authorization: Bearer $API_KEY" "$2"
}

get_item_details() {
    local item_id=$1
    get_json GET "https://api.guildwars2.com/v2/items/$item_id"
}

get_item_price() {
    local item_id=$1
    get_json GET "https://api.guildwars2.com/v2/commerce/prices/$item_id"
}

get_upgrade_price() {
    local upgrade_id=$1
    get_json GET "https://api.guildwars2.com/v2/commerce/prices/$upgrade_id"
}

## Main script
# Get character inventory
inventory=$(get_json GET "https://api.guildwars2.com/v2/characters/$CHARACTER_NAME/inventory")

# Filter for exotic items with upgrades
exotic_items=$(echo "$inventory" | jq '.[] | select(.binding == "Account" and .stats.type == "Exotic" and .upgrades)')

# Loop through exotic items
echo "Item,Upgrade,Item Price,Upgrade Price,Price Difference"
while read -r item; do
    item_id=$(echo "$item" | jq -r '.id')
    item_details=$(get_item_details "$item_id")
    item_price=$(get_item_price "$item_id" | jq -r '.sells.unit_price')

    upgrades=$(echo "$item" | jq -r '.upgrades[]')
    for upgrade in $upgrades; do
        upgrade_price=$(get_upgrade_price "$upgrade" | jq -r '.sells.unit_price')
        price_diff=$((item_price - upgrade_price))

        item_name=$(echo "$item_details" | jq -r '.name')
        upgrade_name=$(echo "$item_details" | jq -r ".details.infix_upgrade.name // \"\"")

        echo "$item_name,$upgrade_name,$item_price,$upgrade_price,$price_diff"
    done
done <<< "$exotic_items" | sort -k5,5nr
