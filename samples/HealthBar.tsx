import { useState } from "react";
import { Bar } from "./Bar";

type Props = { max: number; label?: string };

export function HealthBar({ max, label = "HP" }: Props) {
    const [value, setValue] = useState(max);
    return (
        <div className="health" data-low={value < max * 0.25}>
            <span>{label}: {value}/{max}</span>
            <Bar value={value / max} color="#57C93F" onClick={() => setValue(v => v - 10)} />
        </div>
    );
}
