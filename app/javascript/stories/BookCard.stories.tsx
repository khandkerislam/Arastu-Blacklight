import type { Meta, StoryObj } from '@storybook/react';
import BookCard from '../components/BookCard';

const meta = {
    title: 'Components/BookCard',
    component: BookCard,
    parameters: {
        layout: 'centered',
    },
} satisfies Meta<typeof BookCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
    args: {},
};