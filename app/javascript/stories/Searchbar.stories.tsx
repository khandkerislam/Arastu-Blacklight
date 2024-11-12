import type { Meta, StoryObj } from '@storybook/react';
import Searchbar from '../components/Searchbar';

const meta = {
    title: 'Components/Searchbar',
    component: Searchbar,
    parameters: {
        layout: 'centered',
    },
} satisfies Meta<typeof Searchbar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
    args: {},
};