// Tipos del inventario que sincroniza el servidor
export enum Rarity { Common = 0, Rare = 1, Legendary = 2 }

export interface Item {
    readonly id: string;
    name: string;
    rarity: Rarity;
    stack?: number;
}

type Slots<T extends Item = Item> = Map<number, T>;

export abstract class Inventory<T extends Item> {
    protected slots: Slots<T> = new Map();
    private static readonly MAX = 40;

    public add(item: T, slot?: number): boolean {
        if (this.slots.size >= Inventory.MAX) return false;
        const index = slot ?? this.slots.size;
        this.slots.set(index, { ...item, stack: (item.stack ?? 0) + 1 });
        return true;
    }

    abstract save(): Promise<void>;
}

export const isRare = (item: Item): item is Item & { rarity: Rarity.Rare } => item.rarity === Rarity.Rare;
