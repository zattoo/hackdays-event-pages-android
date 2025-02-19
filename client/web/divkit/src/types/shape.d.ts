import { FixedSize } from './sizes';

export interface RoundedRectangle {
    type: 'rounded_rectangle';
    item_width?: FixedSize;
    item_height?: FixedSize;
    corner_radius?: FixedSize;
}

export interface Circle {
    type: 'circle';
    radius?: FixedSize;
}

export type Shape = RoundedRectangle | Circle;
